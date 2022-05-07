<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card color="#121212" flat>
          <v-card-title class="pb-0">
            <v-spacer />
            新規 Post 作成
            <v-spacer />
          </v-card-title>
        </v-card>
      </v-col>
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
        <v-card outlined>
          <v-col>
            <v-card-text>
              <v-select
                v-model="format"
                :items="choises"
                placeholder="投稿の種類を選択してください"
                :hide-details="!format || format === 'news'"
                outlined
              />
              <template v-if="isFile">
                <v-file-input
                  v-model="file"
                  @change="fetchUrl"
                  placeholder="ファイルを選択してください"
                  chips
                />
                <v-img v-if="showPhoto" :src="url" />
                <VuetifyAudio v-if="showAudio" :file="url" class="black" />
              </template>
              <v-text-field
                v-if="isMediaPass"
                v-model="embedCode"
                :hint="hintText"
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
              <v-card>
                <youtube
                  v-if="showYoutube"
                  :video-id="mediaPass"
                  fitParent
                  resize
                />
              </v-card>
            </v-card-text>
            <v-card-text>
              <v-textarea
                v-model="description"
                label="キャプション"
                auto-grow
                outlined
              />
              <v-btn @click="createPost" block outlined color="grey lighten-1">
                投稿する
              </v-btn>
            </v-card-text>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import VuetifyAudio from "vuetify-audio";

export default {
  components: {
    VuetifyAudio,
  },
  props: ["id"],
  data() {
    return {
      format: "",
      choises: [
        { text: "画像", value: "photo" },
        { text: "音源", value: "audio" },
        { text: "SoundCloud", value: "soundcloud" },
        { text: "YouTube", value: "youtube" },
        { text: "News", value: "news" },
      ],
      file: [],
      url: "",
      embedCode: "",
      mediaPass: "",
      description: "",
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
    showSoundcloud() {
      return this.mediaPass && this.format === "soundcloud";
    },
    showYoutube() {
      return this.mediaPass && this.format === "youtube";
    },
    hintText() {
      if (this.format === "soundcloud") {
        return "投稿したい曲の「share」をクリック、「Embed」を選択して表示された「Code」欄 ( <iframe width= 〜 ) をコピーして貼り付けてください。";
      } else if (this.format === "youtube") {
        return "投稿したい動画の「共有」をクリック、「埋め込み」を選択して表示されたコード ( <iframe width= 〜 ></iframe> ) をコピーして貼り付けてください。";
      } else {
        return "";
      }
    },
  },
  watch: {
    format() {
      this.file = [];
      this.url = "";
      this.embedCode = "";
    },
    embedCode(value) {
      if (this.format === "soundcloud" && value) {
        const start = this.embedCode.indexOf("/tracks/");
        const end = this.embedCode.indexOf("&color=");
        this.mediaPass = this.embedCode.slice(start + 8, end);
      }
      if (this.format === "youtube" && value) {
        const start = this.embedCode.indexOf("/embed/");
        const end = this.embedCode.indexOf('" title=');
        this.mediaPass = this.embedCode.slice(start + 7, end);
      }
      if (!value) this.mediaPass = "";
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
