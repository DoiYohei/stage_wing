<template>
  <div>
    <h1>新規投稿作成</h1>
    <v-container>
      <v-row>
        <v-col md="4" offset-md="4">
          <v-text-field v-model="title" label="タイトル" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-select
            v-model="format"
            :items="choises"
            label="投稿の種類を選択してください"
            solo
          />
        </v-col>
        <template v-if="isFile">
          <v-col md="2" offset-md="5">
            <v-file-input
              v-model="file"
              @change="fetchUrl"
              placeholder="ファイルを選択してください"
              chips
            />
            <v-img v-if="showPhoto" :src="url" />
            <audio v-if="showAudio" controls :src="url" />
          </v-col>
        </template>
        <template v-if="isMediaPass">
          <v-col md="4" offset="4">
            <v-text-field v-model="mediaPass" label="トラックID" />
          </v-col>
        </template>
        <v-col md="6" offset-md="3">
          <v-textarea v-model="description" label="内容" outlined />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="postInputs">投稿する</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      title: "",
      format: "",
      choises: [
        { text: "画像", value: "photo" },
        { text: "音源", value: "audio" },
        { text: "SoundCloud 埋め込み", value: "soundcloud" },
        { text: "YouTube 埋め込み", value: "youtube" },
        { text: "お知らせ", value: "news" },
      ],
      file: [],
      mediaPass: "",
      description: "",
      url: "",
    };
  },
  computed: {
    isFile() {
      return this.format === "photo" || this.format === "audio";
    },
    isMediaPass() {
      return this.format === "soundcloud" || this.format === "youtube";
    },
    showPhoto() {
      return this.url && this.format === "photo";
    },
    showAudio() {
      return this.url && this.format === "audio";
    },
  },
  methods: {
    fetchUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        }
        const fr = new FileReader();
        fr.readAsDataURL(file);
        fr.addEventListener("load", () => {
          this.url = fr.result;
        });
      } else {
        this.url = "";
      }
    },
    async postInputs() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("post[title]", this.title);
      formData.append("post[format]", this.format);
      formData.append("post[description]", this.description);
      if (this.whatStyle === "file") {
        formData.append(`post[${this.format}]`, this.file);
      }
      if (this.whatStyle === "media_pass") {
        formData.append("post[media_pass]", this.mediaPass);
      }
      await this.$axios.post("/posts", formData, token);
      this.$router.replace(`/bands/${this.id}/posts`);
    },
  },
};
</script>
