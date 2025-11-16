import { useEffect, useRef } from 'react';
import { useAuthState, useNotify } from 'react-admin';
import { createConsumer } from "@rails/actioncable"

export const NotificationProvider = () => {
  const { isPending, authenticated } = useAuthState();
  const notify = useNotify();
  const cableRef = useRef(null);
  const subscriptionRef = useRef(null);

  useEffect(() => {
    if (isPending) {
      console.log("NotificationChannel: loading")
      return;
    }

    if (authenticated) {
      console.log("NotificationChannel.connect")

      let token = localStorage.getItem("ra_authorization");
      token = token.split(" ")[1]
      let cable = createConsumer(`/cable?token=${token}`);
      cableRef.current = cable

      subscriptionRef.current = cable.subscriptions.create(
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
      if (subscriptionRef.current) {
        console.log('NotificationChannel: unsubscribe');
        subscriptionRef.current.unsubscribe();
        subscriptionRef.current = null;
        cableRef.current == null;
      }
    }

    return () => {
      if (subscriptionRef.current) {
        console.log("NotificationChannel: unsubscribe")
        subscriptionRef.current.unsubscribe();
        subscriptionRef.current = null;
        cableRef.current == null;
      }
    };
  }, [isPending, authenticated, notify]);

  return null;
};