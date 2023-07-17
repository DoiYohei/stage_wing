<template>
  <v-menu
    ref="menu"
    v-model="menu"
    :close-on-content-click="false"
    :return-value.sync="date"
    transition="scale-transition"
    min-width="auto"
    offset-y
  >
    <template v-slot:activator="{ on, attrs }">
      <ValidationProvider name="開催日" rules="required" v-slot="{ errors }">
        <v-text-field
          :value="formattedDate"
          :error-messages="errors"
          label="開催日（必須）"
          prefix="*"
          readonly
          v-bind="attrs"
          v-on="on"
        />
      </ValidationProvider>
    </template>
    <v-date-picker v-model="date" color="grey lighten-1" no-title scrollable>
      <v-spacer />
      <v-btn @click="$refs.menu.save(date)" color="grey darken-3">OK</v-btn>
      <v-btn @click="menu = false" color="grey darken-3">キャンセル</v-btn>
      <v-spacer />
    </v-date-picker>
  </v-menu>
</template>

<script>
import { ValidationProvider } from "vee-validate";

export default {
  components: {
    ValidationProvider,
  },
  props: {
    value: {
      type: String,
      require: true,
    },
  },
  data() {
    return {
      menu: false,
    };
  },
  computed: {
    date: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    formattedDate() {
      return this.value ? this.$dayjs(this.value).format("YYYY年MM月DD日") : "";
    },
  },
};
</script>
