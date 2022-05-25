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
                  </v-card-text>
                </v-card>
                <ValidationProvider
                  name="Name"
                  rules="max:20|required"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="audience.name"
                    :error-messages="errors"
                    label="Name（必須）"
                    prefix="*"
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="Email"
                  rules="email|required"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="audience.email"
                    :error-messages="errors"
                    label="Email（必須）"
                    prefix="*"
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="Password"
                  rules="max:128|min:8|required"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-if="audience.password !== undefined"
                    v-model="audience.password"
                    :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
                    :error-messages="errors"
                    :type="visible ? 'text' : 'password'"
                    hint="最低8文字です"
                    label="Password（必須）"
                    prefix="*"
                    counter
                    @click:append="visible = !visible"
                  />
                </ValidationProvider>
                <v-alert
                  :value="isError"
                  type="error"
                  dense
                  outlined
                  class="mt-8 mb-0"
                >
                  <slot name="error-text" />
                </v-alert>
              </v-card-text>
              <ButtonSubmitForms @submit-forms="handleSubmit(submitForms)">
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
    isError: {
      type: Boolean,
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
    audience: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    audienceImage() {
      return this.imageUrl
        ? this.imageUrl
        : require("@/assets/img/no-audience-img.jpeg");
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
