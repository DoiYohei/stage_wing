<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
    <CardPageTitle title="アカウント編集" />
    <v-row>
      <v-col :cols="cols" :offset="offset">
        <v-card>
          <v-col sm="10" offset-sm="1">
            <ValidationObserver v-slot="{ handleSubmit }">
              <v-card-text>
                <v-card flat class="d-flex align-center">
                  <v-avatar size="50">
                    <v-img :src="imageForShow" />
                  </v-avatar>
                  <v-card-text class="py-0 pr-0">
                    <InputImage
                      v-model="imageFile"
                      label="プロフィール画像"
                      @load-image="loadImage"
                    />
                  </v-card-text>
                </v-card>
                <InputName v-model="audience.name" label="Name" max="10" />
                <InputEmail v-model="audience.email" />
                <AlertError
                  :value="isError"
                  text="更新できませんでした。"
                  class="mt-8 mb-0"
                />
              </v-card-text>
              <ButtonSubmitForms
                @submit-forms="handleSubmit(patchAudience)"
                text="更新する"
              />
            </ValidationObserver>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import InputImage from "@/components/Inputs/InputImage";
import InputName from "@/components/Inputs/InputName";
import InputEmail from "@/components/Inputs/InputEmail";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";
import { ValidationObserver } from "vee-validate";
import { mapGetters, mapActions } from "vuex";
import { respondCols } from "@/utils/grids";
import { audienceImage } from "@/utils/images";
import { goHome } from "@/utils/routers";

export default {
  components: {
    CardPageTitle,
    InputImage,
    InputName,
    InputEmail,
    AlertError,
    ButtonSubmitForms,
    ValidationObserver,
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
    if (Number(this.id) !== this.audienceId) {
      return goHome();
    } else {
      try {
        const res = await this.$axios.get(
          `/audiences/${this.id}/edit`,
          this.headers
        );
        this.audience = res.data;
      } catch (error) {
        goHome();
      }
    }
  },
  computed: {
    ...mapGetters(["audienceId", "headers"]),
    cols() {
      return respondCols(this.$vuetify.breakpoint, 4, 6, 8, 10, 12);
    },
    offset() {
      return respondCols(this.$vuetify.breakpoint, 4, 3, 2, 1, 0);
    },
    imageForShow() {
      return this.imageUrl
        ? this.imageUrl
        : audienceImage(this.audience.image?.url);
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
        this.setAuthData({ res, userType });
      } catch (error) {
        this.isError = true;
      }
    },
    ...mapActions(["setAuthData"]),
  },
};
</script>
