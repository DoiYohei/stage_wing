<template>
  <v-container>
    <CardPageTitle title="新規 Post 作成" />
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
                <InputPostSelect v-model="format" />
                <InputPostFile v-if="isFile" v-model="file" :format="format" />
                <InputPostEmbedCode
                  v-if="isMediaPass"
                  v-model="embedCode"
                  :format="format"
                  :mediaPass="mediaPass"
                  :isValidMediaPass="isValidMediaPass"
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
import { ValidationObserver } from "vee-validate";
import CardPageTitle from "@/components/Cards/CardPageTitle";
import InputPostSelect from "@/components/Inputs/InputPostSelect";
import InputPostFile from "@/components/Inputs/InputPostFile";
import InputPostEmbedCode from "@/components/Inputs/InputPostEmbedCode";
import InputTextarea from "@/components/Inputs/InputTextarea";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ValidationObserver,
    CardPageTitle,
    InputPostSelect,
    InputPostFile,
    InputPostEmbedCode,
    InputTextarea,
    AlertError,
    ButtonSubmitForms,
  },
  data() {
    return {
      format: "",
      file: null,
      embedCode: "",
      mediaPass: "",
      description: "",
      isError: false,
    };
  },
  computed: {
    ...mapGetters(["bandId", "headers"]),
    isFile() {
      return this.format === "photo" || this.format === "audio";
    },
    isMediaPass() {
      return this.format === "soundcloud" || this.format === "youtube";
    },
    isValidMediaPass() {
      let validation;
      if (this.format === "soundcloud") {
        validation = /^[0-9]+$/;
      } else if (this.format === "youtube") {
        validation = /^[A-Za-z0-9]+$/;
      } else return undefined;
      return validation.test(this.mediaPass);
    },
  },
  watch: {
    format() {
      this.file = null;
      this.embedCode = "";
    },
    embedCode(value) {
      if (this.format === "soundcloud" && value) {
        const start = this.embedCode.indexOf("/tracks/");
        const end = this.embedCode.indexOf("&color=");
        if (start !== -1 && end !== -1) {
          this.mediaPass = this.embedCode.slice(start + 8, end);
        } else this.mediaPass = "";
      } else if (this.format === "youtube" && value) {
        const start = this.embedCode.indexOf("/embed/");
        const end = this.embedCode.indexOf('" title=');
        if (start !== -1 && end !== -1) {
          this.mediaPass = this.embedCode.slice(start + 7, end);
        } else this.mediaPass = "";
      } else this.mediaPass = "";
    },
  },
  methods: {
    async createPost() {
      if (this.isMediaPass && !this.isValidMediaPass) {
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
          if (error.response) this.isError = true;
        }
      }
    },
  },
};
</script>
