<template>
  <v-dialog
    v-model="dialog"
    max-width="1000"
    overlay-color="white"
    overlay-opacity="0.2"
  >
    <v-card color="#121212" class="text-center pt-10 pb-4">
      <v-card-text class="white--text">{{ question }}</v-card-text>
      <v-card-actions class="d-flex justify-center pt-0">
        <v-btn @click="selectExcution" color="grey darken-3" class="mx-2">
          はい
        </v-btn>
        <v-btn @click="closeDialog" color="grey darken-3" class="mx-2">
          いいえ
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    value: {
      type: Boolean,
      require: true,
    },
    question: {
      type: String,
      required: true,
    },
  },
  computed: {
    dialog: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
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
