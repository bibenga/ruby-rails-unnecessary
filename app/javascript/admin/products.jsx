import React from "react";
import { List, Show, SimpleShowLayout, DataTable, ReferenceField, TextField, EmailField } from "react-admin";

export const ProductList = () => (
  <List>
    <DataTable>
      <DataTable.Col source="id" />
      <DataTable.Col source="name" />
      <DataTable.Col source="inventory_count" />
    </DataTable>
  </List>
);

export const ProductShow = (props) => (
  <Show {...props}>
    <SimpleShowLayout>
      <TextField source="id" />
      <TextField source="name" />
    </SimpleShowLayout>
  </Show>
);