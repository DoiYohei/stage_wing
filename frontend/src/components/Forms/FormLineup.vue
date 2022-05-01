<template>
  <v-card-text class="pb-0">
    <v-autocomplete
      v-model="lineup.performers"
      :items="lineup.registeredBands"
      item-text="name"
      no-data-text="登録されていません"
      label="本サイトに登録されているアーティスト"
      chips
      clearable
      deletable-chips
      multiple
      outlined
      return-object
    />
    <v-combobox
      v-model="lineup.unregisteredBands"
      label="本サイトに登録されていないアーティスト"
      hint="各アーティストごとにEnterキーを入力してください。"
      chips
      clearable
      deletable-chips
      multiple
      outlined
    />
  </v-card-text>
</template>

<script>
export default {
  props: {
    value: {
      type: Object,
      require: true,
    },
  },
  computed: {
    lineup: {
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
