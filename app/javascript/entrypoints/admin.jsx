import React from "react";
import { createRoot } from "react-dom/client";
import { fetchUtils, Admin, Resource, ShowGuesser, EditGuesser, Authenticated, Layout } from "react-admin";
import jsonServerProvider from "ra-data-json-server";
import { UserList, UserShow } from "../admin/users";
import { getAuthProvider } from '../admin/authProvider';
import { NotificationProvider } from "../admin/notifications";

const apiUrl = document.getElementById("admin-root").dataset.apiUrl;

const authProvider = getAuthProvider(apiUrl)

const httpClient = (url, options = {}) => {
  if (!options.headers) {
    options.headers = new Headers({ Accept: 'application/json' });
  }
  const authorizationHeader = localStorage.getItem('ra_authorization');
  if (authorizationHeader) {
    options.headers.set('Authorization', authorizationHeader);
  }
  options.credentials = 'omit'; // cookie
  return fetchUtils.fetchJson(url, options);
};

const dataProvider = jsonServerProvider(apiUrl, httpClient);

const AdminLayout = (props) => (
  <>
    <Layout {...props} />
    <NotificationProvider />
  </>
);

const AdminApp = () => (
  <>
    <Admin authProvider={authProvider} dataProvider={dataProvider} layout={AdminLayout}>
      <Resource name="users" list={UserList} show={UserShow} edit={EditGuesser} />
    </Admin>
  </>
);

const container = document.getElementById("admin-root");
const root = createRoot(container);
root.render(<AdminApp />);
