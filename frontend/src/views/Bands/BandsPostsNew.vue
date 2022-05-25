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
            <ValidationObserver v-slot="{ handleSubmit }">
              <v-card-text>
                <ValidationProvider
                  name="投稿の種類"
                  rules="required"
                  v-slot="{ errors }"
                >
                  <v-select
                    v-model="format"
                    :error-messages="errors"
                    :items="choises"
                    placeholder="投稿の種類を選択してください"
                    outlined
                  />
                </ValidationProvider>
                <ValidationProvider
                  v-if="isFile"
                  :name="format === 'photo' ? '画像' : '音源'"
                  :rules="fileRules"
                  v-slot="{ errors }"
                >
                  <v-file-input
                    v-model="file"
                    @change="fetchUrl"
                    :error-messages="errors"
                    placeholder="ファイルを選択してください"
                    chips
                  />
                  <v-img v-if="showPhoto" :src="url" />
                  <VuetifyAudio v-if="showAudio" :file="url" class="black" />
                </ValidationProvider>
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
                <v-alert :value="mediaPassError" type="error" dense outlined>
                  コンテンツが見つかりません
                </v-alert>
              </v-card-text>
              <v-card-text class="pt-0">
                <ValidationProvider
                  name="キャプション"
                  rules="max:500"
                  v-slot="{ errors }"
                >
                  <v-textarea
                    v-model="description"
                    :error-messages="errors"
                    label="キャプション"
                    auto-grow
                    outlined
                  />
                </ValidationProvider>
                <v-alert :value="createError" type="error" dense outlined>
                  投稿できませんでした
                </v-alert>
                <ButtonSubmitForms
                  @submit-forms="handleSubmit(createPost)"
                  class="px-0"
                >
                  投稿する
                </ButtonSubmitForms>
              </v-card-text>
            </ValidationObserver>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import { ValidationProvider, ValidationObserver } from "vee-validate";
import VuetifyAudio from "vuetify-audio";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
    VuetifyAudio,
    ButtonSubmitForms,
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
      file: null,
      url: "",
      embedCode: "",
      mediaPass: "",
      mediaPassError: false,
      description: "",
      createError: false,
    };
  },
  created() {
    if (!this.isAuthenticatedBand || this.userId !== Number(this.id)) {
      return this.$router.replace("/");
    }
  },
  computed: {
    ...mapGetters(["headers", "userId", "isAuthenticatedBand"]),
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
      return this.isValidMediaPass && this.format === "soundcloud";
    },
    showYoutube() {
      return this.isValidMediaPass && this.format === "youtube";
    },
    isValidMediaPass() {
      const alphaNum = /^[A-Za-z0-9]+$/;
      return alphaNum.test(this.mediaPass);
    },
    fileRules() {
      if (this.format === "photo") {
        return "ext:jpg,jpeg,gif,png|required|size:10000";
      } else return "ext:wav,mp3|required|size:10000";
    },
    hintText() {
      if (this.format === "soundcloud") {
        return "投稿したい曲の「share」をクリック、「Embed」を選択して表示された「Code」欄 ( <iframe width= 〜 ) をコピーして貼り付けてください。";
      } else if (this.format === "youtube") {
        return "投稿したい動画の「共有」をクリック、「埋め込む」を選択して表示されたコード ( <iframe width= 〜 ></iframe> ) をコピーして貼り付けてください。";
      } else {
        return "";
      }
    },
  },
  watch: {
    format() {
      this.file = null;
      this.url = "";
      this.embedCode = "";
    },
    embedCode(value) {
      if (this.format === "soundcloud" && value) {
        const start = this.embedCode.indexOf("/tracks/");
        const end = this.embedCode.indexOf("&color=");
        if (start !== -1 && end !== -1) {
          this.mediaPass = this.embedCode.slice(start + 8, end);
        }
      }
      if (this.format === "youtube" && value) {
        const start = this.embedCode.indexOf("/embed/");
        const end = this.embedCode.indexOf('" title=');
        this.mediaPass = this.embedCode.slice(start + 7, end);
      }
      if (!value) this.mediaPass = "";
      if (!this.isValidMediaPass) {
        this.mediaPassError = true;
      } else this.mediaPassError = false;
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
      if (this.isMediaPass && !this.isValidMediaPass) {
        return (this.mediaPassError = true);
      } else {
        try {
          const formData = new FormData();
          formData.append("post[format]", this.format);
          formData.append("post[description]", this.description);
          if (this.isFile) {
            formData.append(`post[${this.format}]`, this.file);
          }
          if (this.isMediaPass) {
            formData.append("post[media_pass]", this.mediaPass);
          }
          await this.$axios.post(
            `/bands/${this.id}/posts`,
            formData,
            this.headers
          );
          this.$router.replace(`/bands/${this.id}`);
        } catch (error) {
          if (error.response) this.createError = true;
        }
      }
    },
  },
};
</script>
