<template>
  <v-card color="grey darken-4" max-width="187" flat>
    <v-card-actions>
      <v-menu
        ref="menu"
        v-model="menu"
        :close-on-content-click="false"
        :return-value.sync="dateInput"
        transition="scale-transition"
        min-width="auto"
        offset-y
      >
        <template v-slot:activator="{ on, attrs }">
          <v-text-field
            :value="formattedDate"
            @click:clear="dateInput = ''"
            label="開催日を指定"
            clearable
            dense
            hide-details
            outlined
            readonly
            v-bind="attrs"
            v-on="on"
          />
        </template>
        <v-date-picker
          v-model="dateInput"
          color="grey lighten-1"
          no-title
          scrollable
        >
          <v-spacer />
          <v-btn @click="$refs.menu.save(dateInput)" color="grey darken-3">
            OK
          </v-btn>
          <v-btn @click="menu = false" color="grey darken-3">キャンセル</v-btn>
          <v-spacer />
        </v-date-picker>
      </v-menu>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
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
    dateInput: {
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
