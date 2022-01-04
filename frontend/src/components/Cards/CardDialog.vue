<template>
  <v-card class="py-10">
    <v-card-text v-text="dialogText" />
    <v-card-actions class="d-flex justify-center">
      <v-btn @click="excuteDialog" class="mx-2">はい</v-btn>
      <v-btn @click="closeDialog" class="mx-2">いいえ</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  name: "CardDialog",
  props: {
    dialogText: {
      type: String,
      required: true,
    },
    selectExcution: {
      type: Function,
      required: true,
    },
    selectCancel: {
      type: Function,
      required: true,
    },
  },
  methods: {
    excuteDialog() {
      this.selectExcution();
    },
    closeDialog() {
      this.selectCancel();
    },
  },
};
</script>
