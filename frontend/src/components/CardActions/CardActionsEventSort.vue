<template>
  <v-card-actions>
    <v-select
      v-model="select"
      @change="sortOrder"
      :items="sortList"
      item-text="value"
      label="並び替え"
      dense
      hide-details
      outlined
      return-object
    />
  </v-card-actions>
</template>

<script>
export default {
  props: {
    value: {
      type: Object,
      require: true,
    },
  },
  data() {
    return {
      sortList: [
        { key: 1, value: "開催が早い順" },
        { key: 2, value: "開催が遅い順" },
      ],
    };
  },
  computed: {
    select: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
  methods: {
    sortOrder() {
      this.$emit("sort-order");
    },
  },
};
</script>
