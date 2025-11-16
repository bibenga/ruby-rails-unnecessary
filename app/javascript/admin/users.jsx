import React from "react";
import { List, Show, SimpleShowLayout, Datagrid, DataTable, ReferenceField, TextField, EmailField } from "react-admin";

export const UserList = () => (
  <List>
    <DataTable>
      {/* <DataTable.Col source="id">
        <ReferenceField source="id" reference="users" link="show" />
      </DataTable.Col> */}
      <DataTable.Col source="id" />
      <DataTable.Col source="nikname" />
    </DataTable>
  </List>
);

export const UserShow = (props) => (
  <Show {...props}>
    <SimpleShowLayout>
      <TextField source="id" />
      <EmailField source="email" />
      <TextField source="nikname" />
    </SimpleShowLayout>
  </Show>
);