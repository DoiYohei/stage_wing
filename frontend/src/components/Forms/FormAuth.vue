<template>
  <v-card>
    <v-col sm="10" offset-sm="1">
      <slot name="card-title" />
      <ValidationObserver v-slot="{ handleSubmit }">
        <v-card-text>
          <template v-if="$route.name !== 'Login'">
            <v-card flat class="d-flex align-center">
              <v-avatar size="50">
                <v-img :src="userImage" />
              </v-avatar>
              <v-card-text class="py-0 pr-0">
                <InputImage
                  v-model="user.inputImage"
                  label="プロフィール画像"
                  @load-image="loadImage"
                />
              </v-card-text>
            </v-card>
            <InputName v-model="user.name" :label="user.nameLabel" max="20" />
          </template>
          <InputEmail v-model="user.email" />
          <InputPassword v-model="user.password" />
          <AlertError
            :value="user.isError"
            :text="user.errorMessage"
            class="mt-8 mb-0"
          />
        </v-card-text>
        <ButtonSubmitForms @submit-forms="handleSubmit(submitForms)">
          <slot name="btn-text" />
        </ButtonSubmitForms>
      </ValidationObserver>
    </v-col>
  </v-card>
</template>

<script>
import { ValidationObserver } from "vee-validate";
import InputImage from "@/components/Inputs/InputImage";
import InputName from "@/components/Inputs/InputName";
import InputEmail from "@/components/Inputs/InputEmail";
import InputPassword from "@/components/Inputs/InputPassword";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ValidationObserver,
    InputImage,
    InputName,
    InputEmail,
    InputPassword,
    AlertError,
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
      imageUrl: "",
    };
  },
  computed: {
    user: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    userImage() {
      return this.imageUrl ? this.imageUrl : this.value.image;
    },
  },
  methods: {
    loadImage(url) {
      this.imageUrl = url;
    },
    submitForms() {
      this.$emit("submit-forms");
    },
  },
};
</script>
