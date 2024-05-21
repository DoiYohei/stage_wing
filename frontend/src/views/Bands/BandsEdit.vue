<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
    <CardPageTitle title="Profile 編集" />
    <v-row class="mt-0">
      <v-col class="px-0">
        <v-card color="#121212" flat class="d-flex flex-wrap">
          <v-col md="7" cols="12" class="pa-0 px-md-2">
            <v-img :src="imageForShow" aspect-ratio="1.37" />
          </v-col>
          <v-col md="5" cols="12" class="text-left py-0">
            <ValidationObserver v-slot="{ handleSubmit }">
              <v-card-text class="pb-0">
                <InputImage
                  v-model="imageFile"
                  label="プロフィール画像"
                  @load-image="loadImage"
                />
                <InputName v-model="band.name" label="Band Name" max="50" />
                <InputEmail v-model="band.email" />
                <InputUrl v-model="band.website" label="ホームページURL" />
                <InputUrl v-model="band.twitter" label="Twitter URL" />
                <InputTextarea
                  v-model="band.profile"
                  label="Profile"
                  max="1000"
                />
                <AlertError :value="isError" text="更新できません。" />
              </v-card-text>
              <ButtonSubmitForms
                @submit-forms="handleSubmit(patchBand)"
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
import InputUrl from "@/components/Inputs/InputUrl";
import InputTextarea from "@/components/Inputs/InputTextarea";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";
import { ValidationObserver } from "vee-validate";
import { mapGetters, mapActions } from "vuex";
import { goHome } from "@/utils/routers";
import { bandImage } from "@/utils/images";

export default {
  components: {
    CardPageTitle,
    InputImage,
    InputName,
    InputEmail,
    InputUrl,
    InputTextarea,
    AlertError,
    ButtonSubmitForms,
    ValidationObserver,
  },
  props: ["id"],
  data() {
    return {
      band: {},
      imageFile: null,
      imageUrl: "",
      isError: false,
    };
  },
  async created() {
    if (Number(this.id) !== this.bandId) {
      return goHome();
    } else {
      try {
        const res = await this.$axios.get(
          `/bands/${this.id}/edit`,
          this.headers
        );
        this.band = res.data;
      } catch (error) {
        goHome();
      }
    }
  },
  computed: {
    ...mapGetters(["bandId", "headers"]),
    imageForShow() {
      return this.imageUrl ? this.imageUrl : bandImage(this.band.image?.url);
    },
  },
  methods: {
    loadImage(url) {
      this.imageUrl = url;
    },
    async patchBand() {
      try {
        const formData = new FormData();
        formData.append("name", this.band.name);
        formData.append("email", this.band.email);
        formData.append("profile", this.band.profile);
        formData.append("website", this.band.website);
        formData.append("twitter", this.band.twitter);
        if (this.imageFile) formData.append("image", this.imageFile);
        const res = await this.$axios.patch("/bands", formData, this.headers);
        const userType = "bands";
        this.setAuthData({ res, userType });
      } catch (error) {
        this.isError = true;
      }
    },
    ...mapActions(["setAuthData"]),
  },
};
</script>
