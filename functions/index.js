const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Inicializa la app de admin (si no lo has hecho)
admin.initializeApp();

// Función que se dispara al crear un nuevo documento en "notes/{noteId}"
exports.notifyNewNote = functions.firestore
  .document("notes/{noteId}")
  .onCreate(async (snapshot, context) => {
    const noteData = snapshot.data() || {};

    const title = noteData.title ?? "Nueva Nota";
    const content = noteData.content ?? "Sin contenido";

    // Opción A: Usar un "topic"
    //   - Cualquiera que se haya suscrito a ese topic recibirá la notificación.
    //   - Por ejemplo, "notesTopic"

    const message = {
      notification: {
        title: `Nota: ${title}`,
        body: content,
      },
      // Enviar a todos suscritos a "notesTopic"
      topic: "all_notes",
      // data opcional para mandar clave/valor
      data: {
        noteId: context.params.noteId, // id del documento
      },
    };

    try {
      // Enviar el mensaje por FCM
      const response = await admin.messaging().send(message);
      console.log("Notificación enviada con éxito:", response);
    } catch (error) {
      console.error("Error al enviar notificación:", error);
    }
  });
