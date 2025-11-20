import React from "react";
import {
  List, Show, SimpleShowLayout, DataTable, TextField, EmailField, DateField,
  ShowButton, EditButton, DeleteWithConfirmButton, BulkDeleteWithConfirmButton,
  BooleanField, Edit, TextInput, BooleanInput, SimpleForm, Create, NullableBooleanInput,
  required, email, useRecordContext
} from "react-admin";

const UserBulkActionButtons = () => (
  <>
    <BulkDeleteWithConfirmButton mutationMode="pessimistic" />
  </>
);

const userFilters = [
  <TextInput source="nikname" />,
  <NullableBooleanInput source="active" />,
];


export const UserList = () => (
  <List filters={userFilters}>
    <DataTable bulkActionButtons={<UserBulkActionButtons />}>
      <DataTable.Col source="id" />
      <DataTable.Col source="nikname" />
      <DataTable.Col source="active" field={BooleanField} disableSort />
      <DataTable.Col source="last_sign_in_at" field={DateField} disableSort />
      <DataTable.Col align="right">
        <ShowButton />
        <EditButton />
        <DeleteWithConfirmButton mutationMode="pessimistic" />
      </DataTable.Col>
    </DataTable>
  </List>
);

const UserTitle = () => {
  const record = useRecordContext();
  if (!record) return null;
  return <span>User "{record.nikname || record.email}"</span>;
};

export const UserShow = (props) => (
  <Show {...props} title={<UserTitle />}>
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
  return { id, nikname, active };
};

export const UserEdit = (props) => (
  <Edit {...props} title={<UserTitle />} transform={userEditTransformer} mutationMode="pessimistic">
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
  return { email, nikname, active };
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
