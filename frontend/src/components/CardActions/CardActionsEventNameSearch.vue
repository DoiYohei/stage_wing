<template>
  <v-card-actions class="pt-0">
    <v-text-field
      v-model="keywordInput"
      placeholder="Event名で検索"
      prepend-inner-icon="mdi-magnify"
      clearable
      hide-details
    />
  </v-card-actions>
</template>

<script>
export default {
  props: {
    value: {
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
