<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
    <CardPageTitle title="新規 Post 作成" />
    <v-row>
      <v-col :cols="cols" :offset="offset">
        <v-card outlined>
          <v-col class="px-0 px-sm-3">
            <ValidationObserver v-slot="{ handleSubmit }">
              <v-card-text>
                <InputPostSelect v-model="format" />
                <InputPostFile v-if="isFile" v-model="file" :format="format" />
                <InputPostEmbedCode
                  v-if="isMediaPass"
                  v-model="embedCode"
                  :format="format"
                  :media-pass="mediaPass"
                />
              </v-card-text>
              <v-card-text class="pt-0">
                <InputTextarea
                  v-model="description"
                  max="500"
                  label="キャプション"
                />
                <AlertError :value="isError" text="投稿できませんでした" />
                <ButtonSubmitForms
                  @submit-forms="handleSubmit(createPost)"
                  text="投稿する"
                  class="px-0"
                />
              </v-card-text>
            </ValidationObserver>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import InputPostSelect from "@/components/Inputs/InputPostSelect";
import InputPostFile from "@/components/Inputs/InputPostFile";
import InputPostEmbedCode from "@/components/Inputs/InputPostEmbedCode";
import InputTextarea from "@/components/Inputs/InputTextarea";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";
import { ValidationObserver } from "vee-validate";
import { mapGetters } from "vuex";
import { respondCols } from "@/utils/grids";

export default {
  components: {
    CardPageTitle,
    InputPostSelect,
    InputPostFile,
    InputPostEmbedCode,
    InputTextarea,
    AlertError,
    ButtonSubmitForms,
    ValidationObserver,
  },
  data() {
    return {
      format: "",
      file: null,
      embedCode: "",
      description: "",
      isError: false,
    };
  },
  computed: {
    ...mapGetters(["bandId", "headers"]),
    cols() {
      return respondCols(this.$vuetify.breakpoint, 6, 8, 10, 12, 12);
    },
    offset() {
      return respondCols(this.$vuetify.breakpoint, 3, 2, 1, 0, 0);
    },
    isFile() {
      return this.format === "photo" || this.format === "audio";
    },
    mediaPass() {
      //ユーザーには埋め込みコード全体(embedCode)を入力してもらう。
      //embedCodeのうち表示に必要な部分(mediaPass)を抽出する。
      if (this.format === "soundcloud" && this.embedCode) {
        const start = this.embedCode.indexOf("/tracks/");
        const end = this.embedCode.indexOf("&color=");
        const mediaPass = this.embedCode.slice(start + 8, end);
        const validation = /^[0-9]+$/;
        return validation.test(mediaPass) ? mediaPass : "";
      } else if (this.format === "youtube" && this.embedCode) {
        const start = this.embedCode.indexOf("/embed/");
        const end = this.embedCode.indexOf("?si=");
        const mediaPass = this.embedCode.slice(start + 7, end);
        const validation = /^[A-Za-z0-9]+$/;
        return validation.test(mediaPass) ? mediaPass : "";
      } else return "";
    },
    isMediaPass() {
      return this.format === "soundcloud" || this.format === "youtube";
    },
  },
  watch: {
    format() {
      this.file = null;
      this.embedCode = "";
    },
  },
  methods: {
    async createPost() {
      if (this.isMediaPass && !this.mediaPass) {
        return (this.isError = true);
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
          await this.$axios.post(`/posts`, formData, this.headers);
          this.$router.replace(`/bands/${this.bandId}`);
        } catch (error) {
          this.isError = true;
        }
      }
    },
  },
};
</script>
