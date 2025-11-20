import React from "react";
import { createRoot } from "react-dom/client";
import {
  fetchUtils, Admin, Resource, ShowGuesser, EditGuesser, Authenticated, Layout,
  bwLightTheme, bwDarkTheme
} from "react-admin";
import jsonServerProvider from "ra-data-json-server";
import { UserList, UserShow, UserEdit, UserCreate } from "../admin/users";
import { getAuthProvider } from '../admin/authProvider';
import { NotificationProvider } from "../admin/notifications";
import { deepmerge } from '@mui/utils';
import UserIcon from '@mui/icons-material/People';

const apiUrl = document.getElementById("admin-root").dataset.apiUrl;
const cableUrl = document.getElementById("admin-root").dataset.cableUrl;

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
    <NotificationProvider cableUrl={cableUrl} />
  </>
);

const lightTheme = deepmerge(bwLightTheme, {
    typography: {
        fontFamily: ['monospace'].join(','),
    },
});

const darkTheme = deepmerge(bwDarkTheme, {
    typography: {
        fontFamily: ['monospace'].join(','),
    },
});

const AdminApp = () => (
  <>
    <Admin
      authProvider={authProvider}
      dataProvider={dataProvider}
      layout={AdminLayout}
      theme={lightTheme}
      darkTheme={darkTheme}
    >
      <Resource name="users" icon={UserIcon} list={UserList} show={UserShow} edit={UserEdit} create={UserCreate} />
    </Admin>
  </>
);

const container = document.getElementById("admin-root");
const root = createRoot(container);
root.render(<AdminApp />);
