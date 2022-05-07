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
          <v-col md="7" cols="12">
            <v-img :src="bandImage" aspect-ratio="1.37" />
          </v-col>
          <v-col md="5" cols="12" class="text-left pb-0">
            <ValidationObserver v-slot="{ invalid }">
              <v-card-text>
                <ValidationProvider
                  name="画像"
                  rules="ext:jpg,jpeg,gif,png|size:10000"
                  v-slot="{ errors }"
                >
                  <v-file-input
                    v-model="inputImage"
                    @change="fetchImageUrl"
                    @blur="fetchOriginal"
                    :error-messages="errors"
                    label="プロフィール画像"
                    chips
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="Band Name"
                  rules="max:50|required"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="band.name"
                    :error-messages="errors"
                    label="Band Name（必須）"
                    prefix="*"
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="Email"
                  rules="email|required"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="band.email"
                    :error-messages="errors"
                    label="Email（必須）"
                    prefix="*"
                    validate-on-blur
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="Password"
                  rules="max:128|min:8|required"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-if="band.password !== undefined"
                    v-model="band.password"
                    @click:append="visible = !visible"
                    :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
                    :error-messages="errors"
                    :type="visible ? 'text' : 'password'"
                    hint="最低8文字です"
                    label="Password（必須）"
                    prefix="*"
                    counter
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="URL"
                  :rules="{
                    regex: /https?:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/,
                  }"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="band.website"
                    :error-messages="errors"
                    label="ホームページURL"
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="URL"
                  :rules="{
                    regex: /https?:\/\/[-_.!~*\'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/,
                  }"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="band.twitter"
                    :error-messages="errors"
                    label="Twitter URL"
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="Profile"
                  rules="max:1000"
                  v-slot="{ errors }"
                >
                  <v-textarea
                    v-model="band.profile"
                    :error-messages="errors"
                    label="Profile"
                    background-color="grey darken-4"
                    auto-grow
                    hide-details
                    outlined
                  />
                </ValidationProvider>
                <v-alert
                  :value="band.isError"
                  type="error"
                  dense
                  outlined
                  class="mt-8 mb-0"
                >
                  <slot name="error-text" />
                </v-alert>
              </v-card-text>
              <ButtonSubmitForms :invalid="invalid" @submit-forms="submitForms">
                <slot name="btn-text" />
              </ButtonSubmitForms>
            </ValidationObserver>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { ValidationProvider, ValidationObserver } from "vee-validate";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
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
