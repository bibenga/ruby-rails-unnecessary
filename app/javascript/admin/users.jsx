import React from "react";
import {
  List, Show, SimpleShowLayout, DataTable, TextField, EmailField, DateField, ShowButton, EditButton,
  BooleanField, Edit, TextInput, BooleanInput, SimpleForm
} from "react-admin";

export const UserList = () => (
  <List>
    <DataTable>
      <DataTable.Col source="id" />
      <DataTable.Col source="nikname" />
      <DataTable.Col source="active" field={BooleanField} disableSort />
      <DataTable.Col source="last_sign_in_at" field={DateField} disableSort />
      <DataTable.Col>
        <ShowButton />
        <EditButton />
      </DataTable.Col>
    </DataTable>
  </List>
);

export const UserShow = (props) => (
  <Show {...props}>
    <SimpleShowLayout>
      <TextField source="id" />
      <EmailField source="email" />
      <TextField source="nikname" />
      <BooleanField source="active" />
      <DateField source="last_sign_in_at" showTime />
      <DateField source="created_at" showTime />
    </SimpleShowLayout>
  </Show>
);

const userEditTransformer = (data) => {
  const { id, nikname, active } = data;
  return {
    id,
    nikname,
    active,
  };
};
export const UserEdit = (props) => (
  <Edit {...props} transform={userEditTransformer} mutationMode="pessimistic">
    <SimpleForm>
      <TextInput source="id" disabled />
      <TextInput source="nikname" />
      <BooleanInput source="active" />
    </SimpleForm>
  </Edit>
);
