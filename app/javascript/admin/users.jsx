import React from "react";
import {
  List, Show, SimpleShowLayout, DataTable, TextField, EmailField, DateField, 
  ShowButton, EditButton, DeleteButton, DeleteWithConfirmButton, BulkDeleteWithConfirmButton,
  BooleanField, Edit, TextInput, BooleanInput, SimpleForm, Create,
  required, email
} from "react-admin";

const UserBulkActionButtons = () => (
    <>
        <BulkDeleteWithConfirmButton mutationMode="pessimistic"/>
    </>
);

export const UserList = () => (
  <List>
    <DataTable bulkActionButtons={<UserBulkActionButtons />}>
      <DataTable.Col source="id" />
      <DataTable.Col source="nikname" />
      <DataTable.Col source="active" field={BooleanField} disableSort />
      <DataTable.Col source="last_sign_in_at" field={DateField} disableSort />
      <DataTable.Col>
        <ShowButton />
        <EditButton />
        <DeleteWithConfirmButton mutationMode="pessimistic" />
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
      <TextInput source="email" disabled />
      <TextInput source="nikname" validate={[required()]} />
      <BooleanInput source="active" />
    </SimpleForm>
  </Edit>
);

const createEditTransformer = (data) => {
  const { email, nikname, active } = data;
  return {
    email,
    nikname,
    active,
  };
};

export const UserCreate = (props) => (
  <Create {...props} transform={createEditTransformer} mutationMode="pessimistic" redirect="list">
    <SimpleForm>
      <TextInput source="email" validate={[required(), email()]} />
      <TextInput source="nikname" validate={[required()]} />
      <BooleanInput source="active" />
    </SimpleForm>
  </Create>
);
