<template>
  <v-container>
    <CardPageTitle title="アカウント編集" />
    <v-row>
      <v-col
        xl="4"
        offset-xl="4"
        lg="6"
        offset-lg="3"
        md="8"
        offset-md="2"
        sm="10"
        offset-sm="1"
      >
        <v-card>
          <v-col sm="10" offset-sm="1">
            <ValidationObserver v-slot="{ handleSubmit }">
              <v-card-text>
                <v-card flat class="d-flex align-center">
                  <v-avatar size="50">
                    <v-img :src="audienceImage" />
                  </v-avatar>
                  <v-card-text class="py-0 pr-0">
                    <InputImage
                      v-model="imageFile"
                      label="プロフィール画像"
                      @load-image="loadImage"
                    />
                  </v-card-text>
                </v-card>
                <InputName v-model="audience.name" label="Name" max="20" />
                <InputEmail v-model="audience.email" />
                <AlertError
                  :value="isError"
                  text="更新できませんでした。"
                  class="mt-8 mb-0"
                />
              </v-card-text>
              <ButtonSubmitForms @submit-forms="handleSubmit(patchAudience)">
                更新する
              </ButtonSubmitForms>
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
import InputImage from "@/components/Inputs/InputImage";
import InputName from "@/components/Inputs/InputName";
import InputEmail from "@/components/Inputs/InputEmail";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ValidationObserver,
    CardPageTitle,
    InputImage,
    InputName,
    InputEmail,
    AlertError,
    ButtonSubmitForms,
  },
  props: ["id"],
  data() {
    return {
      audience: {},
      imageFile: null,
      imageUrl: "",
      isError: false,
    };
  },
  async created() {
    try {
      if (Number(this.id) !== this.audienceId) throw { response: "status 401" };
      const res = await this.$axios.get(
        `/audiences/${this.id}/edit`,
        this.headers
      );
      this.audience = res.data;
    } catch (error) {
      if (error.response) this.$router.replace("/");
    }
  },
  computed: {
    ...mapGetters(["audienceId", "headers"]),
    audienceImage() {
      return this.imageUrl ? this.imageUrl : this.defaultUrl;
    },
    defaultUrl() {
      return this.audience.image
        ? this.audience.image.url
        : require("@/assets/img/no-audience-img.jpeg");
    },
  },
  methods: {
    loadImage(url) {
      this.imageUrl = url;
    },
    async patchAudience() {
      try {
        const formData = new FormData();
        formData.append("name", this.audience.name);
        formData.append("email", this.audience.email);
        if (this.imageFile) formData.append("image", this.imageFile);
        const res = await this.$axios.patch(
          "/audiences",
          formData,
          this.headers
        );
        const userType = "audiences";
        this.$store.dispatch("setAuthData", { res, userType });
      } catch (error) {
        if (error.response) this.isError = true;
      }
    },
  },
};
</script>
