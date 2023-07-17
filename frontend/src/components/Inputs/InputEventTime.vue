<template>
  <v-card height="66" width="50%" color="#121212" flat>
    <v-menu
      ref="menu"
      v-model="menu"
      :close-on-content-click="false"
      :return-value.sync="time"
      transition="scale-transition"
      max-width="290px"
      min-width="290px"
      offset-y
    >
      <template v-slot:activator="{ on, attrs }">
        <v-text-field
          v-model="time"
          :label="label"
          readonly
          v-bind="attrs"
          v-on="on"
        />
      </template>
      <v-time-picker
        v-if="menu"
        v-model="time"
        color="#1E1E1E"
        format="24hr"
        full-width
      >
        <v-spacer />
        <v-btn @click="$refs.menu.save(time)" color="grey darken-3">OK</v-btn>
        <v-btn @click="menu = false" color="grey darken-3">キャンセル</v-btn>
        <v-spacer />
      </v-time-picker>
    </v-menu>
  </v-card>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      require: true,
    },
    label: {
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
    time: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
};
</script>
