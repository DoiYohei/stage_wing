<template>
  <div>
    <v-text-field
      v-model="embedCode"
      :hint="hint"
      :error-messages="errorMessage"
      placeholder='例) <iframe width="500" height="500" 〜'
      clearable
      dense
      outlined
      persistent-hint
      single-line
    />
    <iframe
      v-if="showSoundcloud"
      :src="`https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/${mediaPass}`"
      width="100%"
      height="166"
      scrolling="no"
      frameborder="no"
    />
    <v-card flat>
      <youtube v-if="showYoutube" :video-id="mediaPass" fitParent resize />
    </v-card>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      require: true,
    },
    format: {
      type: String,
      require: true,
    },
    mediaPass: {
      type: String,
      require: true,
    },
    isValidMediaPass: {
      type: Boolean,
      require: true,
    },
  },
  computed: {
    embedCode: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    hint() {
      if (this.format === "soundcloud") {
        return "投稿したい曲の「share」をクリック、「Embed」を選択して表示された「Code」欄 ( <iframe width= 〜 ) を全てコピーして貼り付けてください。";
      } else if (this.format === "youtube") {
        return "投稿したい動画の「共有」をクリック、「埋め込む」を選択して表示されたコード ( <iframe width= 〜 ) を全てコピーして貼り付けてください。";
      } else return "";
    },
    errorMessage() {
      return this.value && !this.isValidMediaPass
        ? "コンテンツが見つかりません"
        : "";
    },
    showSoundcloud() {
      return this.value && this.format === "soundcloud";
    },
    showYoutube() {
      return this.value && this.format === "youtube";
    },
  },
};
</script>
