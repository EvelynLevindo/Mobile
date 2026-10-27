const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getAuth } = require("firebase-admin/auth");

initializeApp();
const db = getFirestore();
const auth = getAuth();

/**
 * Convidar usuário registrado por e-mail para colaborar em uma playlist.
 *
 * Validações de segurança no servidor:
 * 1. O chamador precisa estar autenticado.
 * 2. Valida o formato e obrigatoriedade do e-mail e ID da playlist.
 * 3. Busca a playlist no Firestore e valida sua existência.
 * 4. Verifica se o chamador é de fato o proprietário (ownerId) da playlist.
 * 5. Resolve o usuário pelo e-mail com segurança via Firebase Auth / Firestore users.
 * 6. Impede convidar o próprio proprietário.
 * 7. Impede adicionar usuários que já são colaboradores (evita duplicatas).
 * 8. Atualiza atomicamente a lista de colaboradores via FieldValue.arrayUnion.
 */
exports.inviteCollaborator = onCall(
  {
    cors: true,
  },
  async (request) => {
    // 1. Validação de autenticação
    if (!request.auth || !request.auth.uid) {
      throw new HttpsError(
        "unauthenticated",
        "Você precisa estar autenticado para convidar colaboradores."
      );
    }

    const callerUid = request.auth.uid;
    const { playlistId, email } = request.data || {};

    // 2. Validação dos parâmetros
    if (!playlistId || typeof playlistId !== "string" || playlistId.trim() === "") {
      throw new HttpsError(
        "invalid-argument",
        "O identificador da playlist é obrigatório."
      );
    }

    if (!email || typeof email !== "string" || email.trim() === "") {
      throw new HttpsError(
        "invalid-argument",
        "O e-mail do colaborador é obrigatório."
      );
    }

    const cleanEmail = email.trim().toLowerCase();

    // 3. Buscar playlist no Firestore
    const playlistRef = db.collection("playlists").doc(playlistId);
    const playlistDoc = await playlistRef.get();

    if (!playlistDoc.exists) {
      throw new HttpsError("not-found", "A playlist informada não foi encontrada.");
    }

    const playlist = playlistDoc.data();

    // 4. Verificar se quem chama é o proprietário da playlist
    if (playlist.ownerId !== callerUid) {
      throw new HttpsError(
        "permission-denied",
        "Apenas o proprietário da playlist tem permissão para convidar novos colaboradores."
      );
    }

    // 5. Resolver usuário pelo e-mail
    let targetUid = null;
    let targetDisplayName = "Colaborador";
    let targetPhotoUrl = null;

    try {
      // Tenta buscar no Firebase Auth
      const userRecord = await auth.getUserByEmail(cleanEmail);
      targetUid = userRecord.uid;
      targetDisplayName = userRecord.displayName || targetDisplayName;
      targetPhotoUrl = userRecord.photoURL || null;
    } catch (authError) {
      // Se não encontrou no Auth diretamente, busca na coleção 'users' do Firestore
      const usersQuery = await db
        .collection("users")
        .where("email", "==", cleanEmail)
        .limit(1)
        .get();

      if (!usersQuery.empty) {
        const uDoc = usersQuery.docs[0];
        const uData = uDoc.data();
        targetUid = uDoc.id;
        targetDisplayName = uData.displayName || targetDisplayName;
        targetPhotoUrl = uData.photoUrl || null;
      }
    }

    if (!targetUid) {
      throw new HttpsError(
        "not-found",
        `Nenhum usuário cadastrado com o e-mail "${cleanEmail}". O convidado precisa criar uma conta no Musa.`
      );
    }

    // 6. Verificar se não é o próprio proprietário
    if (targetUid === playlist.ownerId) {
      throw new HttpsError(
        "invalid-argument",
        "O usuário informado é o proprietário desta playlist."
      );
    }

    // 7. Verificar se já não é colaborador
    const currentCollaborators = Array.isArray(playlist.collaborators)
      ? playlist.collaborators
      : [];

    if (currentCollaborators.includes(targetUid)) {
      throw new HttpsError(
        "already-exists",
        "Este usuário já faz parte dos colaboradores da playlist."
      );
    }

    // 8. Atualizar a playlist atomicamente
    await playlistRef.update({
      collaborators: FieldValue.arrayUnion(targetUid),
      updatedAt: FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      message: "Colaborador adicionado com sucesso.",
      user: {
        uid: targetUid,
        email: cleanEmail,
        displayName: targetDisplayName,
        photoUrl: targetPhotoUrl,
      },
    };
  }
);

/**
 * Remover colaborador de uma playlist.
 *
 * Validações de segurança:
 * 1. O chamador precisa estar autenticado.
 * 2. Apenas o proprietário pode remover colaboradores, OU o próprio colaborador pode se remover (sair).
 * 3. Remove atomicamente via FieldValue.arrayRemove.
 */
exports.removeCollaborator = onCall(
  {
    cors: true,
  },
  async (request) => {
    if (!request.auth || !request.auth.uid) {
      throw new HttpsError("unauthenticated", "Autenticação obrigatória.");
    }

    const callerUid = request.auth.uid;
    const { playlistId, collaboratorUid } = request.data || {};

    if (!playlistId || !collaboratorUid) {
      throw new HttpsError(
        "invalid-argument",
        "playlistId e collaboratorUid são obrigatórios."
      );
    }

    const playlistRef = db.collection("playlists").doc(playlistId);
    const playlistDoc = await playlistRef.get();

    if (!playlistDoc.exists) {
      throw new HttpsError("not-found", "Playlist não encontrada.");
    }

    const playlist = playlistDoc.data();

    // Permissão: somente o proprietário ou o próprio colaborador pode efetuar a remoção
    const isOwner = playlist.ownerId === callerUid;
    const isSelf = collaboratorUid === callerUid;

    if (!isOwner && !isSelf) {
      throw new HttpsError(
        "permission-denied",
        "Você não tem permissão para remover este colaborador."
      );
    }

    await playlistRef.update({
      collaborators: FieldValue.arrayRemove(collaboratorUid),
      updatedAt: FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      message: "Colaborador removido com sucesso.",
    };
  }
);
