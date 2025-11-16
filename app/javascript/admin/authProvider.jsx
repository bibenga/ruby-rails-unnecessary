// import { AuthProvider } from "react-admin";

export const getAuthProvider = (apiUrl) => ({
  login: async ({ username, password }) => {
    const request = new Request(`${apiUrl}/auth/sign_in`, {
      method: 'POST',
      body: JSON.stringify({ email: username, password: password }),
      headers: new Headers({ 'Content-Type': 'application/json' }),
    });

    try {
      const response = await fetch(request);

      if (response.status < 200 || response.status >= 300) {
        const errorBody = await response.json();
        return Promise.reject(errorBody.error || 'Auth error');
      }

      const authorizationHeader = response.headers.get('Authorization');
      if (authorizationHeader) {
        const data = await response.json()

        localStorage.setItem('ra_authorization', authorizationHeader);
        localStorage.setItem('ra_isAuthenticated', 'true');
        localStorage.setItem('ra_user', JSON.stringify(data.user))
        return Promise.resolve();
      } else {
        return Promise.reject('The Authorization header was not found in the response..');
      }
    } catch (error) {
      return Promise.reject(error.message || 'Network error when logging in');
    }
  },

  logout: async () => {
    const accessToken = localStorage.getItem('ra_authorization');

    if (accessToken) {
      const request = new Request(`${apiUrl}/auth/sign_out`, {
        method: 'DELETE',
        headers: new Headers({
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        }),
      });
      try {
        await fetch(request);
      } catch (e) {
      }
    }

    localStorage.removeItem('ra_authorization');
    localStorage.removeItem('ra_isAuthenticated');
    localStorage.removeItem('ra_user')

    return Promise.resolve();
  },

  checkAuth: () => {
    const isAuthenticated = localStorage.getItem('ra_isAuthenticated') === "true"
    // console.log(`checkAuth: ${isAuthenticated}`)
    if (isAuthenticated) {
      // console.log("checkAuth: resolve")
      return Promise.resolve()
    }
    // console.log("checkAuth: reject")
    return Promise.reject();
  },

  checkError: ({ status }) => {
    if (status === 401 || status === 403) {
      localStorage.clear();
      return Promise.reject();
    }
    return Promise.resolve();
  },

  getIdentity: async () =>{
    // console.log("getIdentity")
    const user = JSON.parse(localStorage.getItem('ra_user'));

    // const accessToken = localStorage.getItem('ra_authorization');
    // const request = new Request(`${apiUrl}/auth/iam`, {
    //   headers: new Headers({
    //     'Content-Type': 'application/json',
    //     'Authorization': accessToken,
    //   }),
    // });
    // const response = await fetch(request);
    // const user = await response.json()

    return Promise.resolve({
      id: user.id,
      fullName: user.nikname || user.email,
    })
  },

  getPermissions: () => Promise.resolve(),
});
