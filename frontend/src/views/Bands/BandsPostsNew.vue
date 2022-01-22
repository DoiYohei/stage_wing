<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">新規Post作成</v-col>
    </v-row>
    <v-row>
      <v-col
        xl="4"
        offset-xl="4"
        lg="6"
        offset-lg="3"
        sm="8"
        offset-sm="2"
        cols="10"
        offset="1"
      >
        <v-card>
          <v-col>
            <v-card-text>
              <v-select
                v-model="format"
                :items="choises"
                label="投稿の種類を選択してください"
                solo
              />
              <template v-if="isFile">
                <v-file-input
                  v-model="file"
                  @change="fetchUrl"
                  placeholder="ファイルを選択してください"
                  chips
                />
                <v-img v-if="showPhoto" :src="url" />
                <vuetify-audio v-if="showAudio" :file="url" />
              </template>
              <v-text-field
                v-if="isMediaPass"
                v-model="mediaPass"
                label="トラックID"
              />
            </v-card-text>
            <v-card-text>
              <v-textarea
                v-model="description"
                label="内容"
                auto-grow
                hide-details
                outlined
              />
            </v-card-text>
            <v-card-text>
              <v-btn width="100%" @click="createPost">投稿する</v-btn>
            </v-card-text>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: ["id"],
  data() {
    return {
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
    ...mapGetters(["headers"]),
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
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.url = fr.result;
          });
        }
      } else {
        this.url = "";
      }
    },
    async createPost() {
      const formData = new FormData();
      formData.append("post[format]", this.format);
      formData.append("post[description]", this.description);
      if (this.isFile) {
        formData.append(`post[${this.format}]`, this.file);
      }
      if (this.isMediaPass) {
        formData.append("post[media_pass]", this.mediaPass);
      }
      await this.$axios.post(`/bands/${this.id}/posts`, formData, this.headers);
      this.$router.replace(`/bands/${this.id}`);
    },
  },
};
</script>
