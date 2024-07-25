<template>
  <v-card>
    <v-col sm="10" offset-sm="1">
      <slot name="card-title" />
      <ValidationObserver v-slot="{ handleSubmit }">
        <v-card-text>
          <template v-if="$route.name === 'Signup'">
            <v-card flat data-jest="input-img" class="d-flex align-center">
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
            <InputName
              v-model="user.name"
              :label="user.nameLabel"
              :max="nameLength"
              data-jest="input-name"
            />
          </template>
          <InputEmail v-model="user.email" data-jest="input-email" />
          <InputPassword v-model="user.password" data-jest="input-password" />
          <AlertError
            :value="user.isError"
            :text="user.errorMessage"
            class="mt-8 mb-0"
          />
        </v-card-text>
        <ButtonSubmitForms
          @submit-forms="handleSubmit(submitForms)"
          :text="btnText"
        />
      </ValidationObserver>
      <v-card-actions class="underline pt-4">
        <v-spacer />
        <v-btn text @click.stop="user.resetDialog = true">
          パスワードを忘れた{{ user.cardTitle }}
        </v-btn>
        <v-spacer />
      </v-card-actions>
      <DialogEmailForm v-model="user" @submit-email="resetPassword" />
    </v-col>
  </v-card>
</template>

<script>
import InputImage from "@/components/Inputs/InputImage";
import InputName from "@/components/Inputs/InputName";
import InputEmail from "@/components/Inputs/InputEmail";
import InputPassword from "@/components/Inputs/InputPassword";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";
import DialogEmailForm from "@/components/Dialogs/DialogEmailForm";
import { ValidationObserver } from "vee-validate";

export default {
  components: {
    InputImage,
    InputName,
    InputEmail,
    InputPassword,
    AlertError,
    ButtonSubmitForms,
    DialogEmailForm,
    ValidationObserver,
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
      mail: "",
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
    nameLength() {
      // Audienceの場合は10、Bandの場合は50。
      return this.value.nameLabel === "Name" ? "10" : "50";
    },
    btnText() {
      return this.$route.name == "Signup" ? "Sign Up" : "Log In";
    },
  },
  methods: {
    loadImage(url) {
      this.imageUrl = url;
    },
    submitForms() {
      this.$emit("submit-forms");
    },
    resetPassword() {
      this.$emit("reset-password");
    },
  },
};
</script>
