<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card color="#121212" flat>
          <v-card-title class="pb-0">
            <v-spacer />
            <slot name="page-title" />
            <v-spacer />
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
    <v-row class="mt-0">
      <v-col>
        <v-card color="#121212" flat class="d-flex flex-wrap">
          <v-col md="7" sm="12">
            <v-img :src="bandImage" aspect-ratio="1.37" />
          </v-col>
          <v-col class="text-left pb-0">
            <v-card-text>
              <v-file-input
                v-model="inputImage"
                @change="fetchImageUrl"
                @blur="fetchOriginal"
                label="プロフィール画像"
                chips
              />
              <v-text-field v-model="band.name" label="Band Name" />
              <v-text-field v-model="band.email" label="Email" />
              <v-text-field
                v-if="band.password !== undefined"
                v-model="band.password"
                :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
                :type="visible ? 'text' : 'password'"
                label="Password"
                hint="最低8文字です"
                counter
                @click:append="visible = !visible"
              />
              <v-text-field v-model="band.website" label="ホームページURL" />
              <v-text-field v-model="band.twitter" label="Twitter URL" />
              <v-textarea
                v-model="band.profile"
                label="Profile"
                background-color="grey darken-4"
                auto-grow
                hide-details
                outlined
              />
            </v-card-text>
            <ButtonSubmitForms @submit-forms="submitForms">
              <slot name="btn-text" />
            </ButtonSubmitForms>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ButtonSubmitForms,
  },
  props: {
    value: {
      type: Object,
      require: true,
    },
  },
  data() {
    return {
      inputImage: null,
      imageUrl: "",
      visible: false,
    };
  },
  computed: {
    band: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    bandImage() {
      return this.value.image && this.value.image.url
        ? this.value.image.url
        : require("@/assets/img/no-band-img.jpg");
    },
  },
  watch: {
    value() {
      this.fetchOriginal();
    },
    inputImage() {
      this.fetchOriginal();
    },
  },
  methods: {
    fetchImageUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.imageUrl = fr.result;
          });
        }
      } else {
        this.imageUrl = "";
      }
    },
    fetchOriginal() {
      if (!this.imageUrl && this.value.image) {
        this.imageUrl = this.value.image.url;
      }
    },
    submitForms() {
      this.$emit("submit-forms", this.inputImage);
    },
  },
};
</script>
