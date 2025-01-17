const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Inicializa la app de admin
admin.initializeApp();

// Función que se dispara al crear un nuevo documento en "notes/{noteId}"
exports.notifyNewNote = functions.firestore
  .document("notes/{noteId}")
  .onCreate(async (snapshot, context) => {
    console.log("Nueva nota detectada:", context.params.noteId);

    const noteData = snapshot.data() || {};
    const title = noteData.title || "Nueva Nota";
    const content = noteData.content || "Sin contenido";

    const message = {
      notification: {
        title: `Nota: ${title}`,
        body: content,
      },
      topic: "all_notes",
    };

    try {
      const response = await admin.messaging().send(message);
      console.log("Notificación enviada:", response);
    } catch (error) {
      console.error("Error al enviar notificación:", error);
    }
  });

// Función para enviar notificaciones diarias sobre clases muestra
exports.notifySampleClasses = functions.pubsub
  .schedule("every day 00:00")
  .onRun(async () => {
    console.log("Verificando clases muestra programadas para hoy...");
    
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Normalizamos la fecha actual

    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1); // Día siguiente

    try {
      // Consulta Firestore para encontrar clases muestra de hoy
      const snapshot = await admin.firestore()
        .collection("students")
        .where("classDate", ">=", today.toISOString())
        .where("classDate", "<", tomorrow.toISOString())
        .where("level", "==", "Clase Muestra")
        .get();

      if (snapshot.empty) {
        console.log("No hay clases muestra para hoy.");
        return null;
      }

      // Crear el mensaje de notificación
      const messages = snapshot.docs.map((doc) => {
        const student = doc.data();
        return {
          notification: {
            title: "Recordatorio Clase Muestra",
            body: `Tienes una clase muestra con ${student.name} hoy.`,
          },
          topic: "sample_classes", // Tema específico para clases muestra
        };
      });

      // Enviar todas las notificaciones
      const responses = await Promise.all(
        messages.map((message) => admin.messaging().send(message))
      );
      console.log("Notificaciones enviadas:", responses.length);

      return null;
    } catch (error) {
      console.error("Error al enviar notificaciones de clases muestra:", error);
      throw error;
    }
  });