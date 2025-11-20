import { useEffect, useRef } from 'react';
import { useAuthState, useNotify } from 'react-admin';
import { createConsumer, logger } from "@rails/actioncable"

logger.enabled = true

export const NotificationProvider = (props) => {
  const cableUrl = props.cableUrl || "/cable"
  const { isPending, authenticated } = useAuthState();
  const notify = useNotify();
  const cableRef = useRef(null);
  const notificationChannelRef = useRef(null);

  useEffect(() => {
    if (isPending) {
      console.log("NotificationChannel: loading")
      return;
    }

    if (authenticated) {
      console.log("NotificationChannel.connect")

      let token = localStorage.getItem("ra_authorization");
      token = token.split(" ")[1]
      let cable = createConsumer(`${cableUrl}?token=${token}`);
      cableRef.current = cable

      notificationChannelRef.current = cable.subscriptions.create(
        'NotificationChannel',
        {
          connected() {
            console.log("NotificationChannel.connected")
          },

          disconnected() {
            console.log("NotificationChannel.disconnected")
          },

          rejected() {
            console.log("NotificationChannel.rejected")
          },

          received: (data) => {
            console.log("NotificationChannel.received", data)
            // notify(data.message, { type: data.type });
          },
        }
      );
    } else {
      console.log("NotificationChannel: is not authenticated, unsubscribe")
      if (notificationChannelRef.current) {
        console.log('NotificationChannel: unsubscribe');
        notificationChannelRef.current.unsubscribe();
        notificationChannelRef.current = null;
        cableRef.current.disconnect();
        cableRef.current == null;
      }
    }

    return () => {
      if (notificationChannelRef.current) {
        console.log("NotificationChannel: unsubscribe")
        notificationChannelRef.current.unsubscribe();
        notificationChannelRef.current = null;
        cableRef.current.disconnect();
        cableRef.current == null;
      }
    };
  }, [isPending, authenticated, notify]);

  return null;
};