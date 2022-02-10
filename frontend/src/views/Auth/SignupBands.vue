<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">Signup</v-col>
    </v-row>
    <CardBandForms
      v-model="band"
      btn-text="Sign Up"
      :deliveryForms="signUpBand"
    />
  </v-container>
</template>

<script>
import CardBandForms from "@/components/Cards/CardBandForms";

export default {
  components: {
    CardBandForms,
  },
  data() {
    return {
      band: {
        name: "",
        email: "",
        password: "",
        profile: "",
        website: "",
        twitter: "",
        image: null,
      },
    };
  },
  methods: {
    signUpBand(image) {
      const formData = new FormData();
      formData.append("name", this.band.name);
      formData.append("email", this.band.email);
      formData.append("password", this.band.password);
      formData.append("image", image);
      formData.append("profile", this.band.profile);
      formData.append("website", this.band.website);
      formData.append("twitter", this.band.twitter);
      this.$store.dispatch("signupBand", formData);
    },
  },
};
</script>
