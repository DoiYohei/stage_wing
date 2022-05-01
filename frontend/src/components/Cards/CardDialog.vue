<template>
  <v-card outlined class="text-center py-8">
    <v-card-text v-text="dialogText" class="white--text" />
    <v-card-actions class="d-flex justify-center py-0">
      <v-btn @click="selectExcution" color="grey darken-3" class="mx-2">
        はい
      </v-btn>
      <v-btn @click="closeDialog" color="grey darken-3" class="mx-2">
        いいえ
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    dialogText: {
      type: String,
      required: true,
    },
  },
  methods: {
    selectExcution() {
      this.$emit("select-excution");
    },
    closeDialog() {
      this.$emit("close-dialog");
    },
  },
};
</script>
