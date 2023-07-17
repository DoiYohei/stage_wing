<template>
  <v-card color="grey darken-4" min-width="207" flat>
    <v-card-actions class="pt-0">
      <v-text-field
        v-model="keywordInput"
        :placeholder="`${label}名で検索`"
        prepend-inner-icon="mdi-magnify"
        clearable
        hide-details
      />
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
    label: {
      type: String,
      require: true,
    },
  },
  computed: {
    keywordInput: {
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
