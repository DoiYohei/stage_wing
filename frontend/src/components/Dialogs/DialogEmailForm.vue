<template>
  <v-dialog
    v-model="user.resetDialog"
    max-width="500"
    overlay-color="white"
    overlay-opacity="0.2"
  >
    <v-card color="#121212">
      <v-container>
        <CardPageTitle title="Password Reset" />
        <v-row>
          <v-col>
            <v-card-text class="text-center py-0">
              「 {{ user.cardTitle }} 」
            </v-card-text>
            <v-card-text>
              登録しているメールアドレスを入力して、送信ボタンを押してください。パスワード再設定のためのメールをお送りします。
            </v-card-text>
            <ValidationObserver v-slot="{ handleSubmit }">
              <v-card-text class="py-0">
                <InputEmail v-model="user.resetEmail" />
              </v-card-text>
              <v-card-text class="py-0">
                <AlertError
                  :value="user.resetError"
                  text="入力されたメールアドレスは登録されていません。"
                />
              </v-card-text>
              <ButtonSubmitForms
                @submit-forms="handleSubmit(submitEmail)"
                text="送信"
              />
              <ButtonSubmitForms
                @submit-forms="user.resetDialog = false"
                text="キャンセル"
              />
            </ValidationObserver>
          </v-col>
        </v-row>
      </v-container>
    </v-card>
  </v-dialog>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import InputEmail from "@/components/Inputs/InputEmail";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";
import { ValidationObserver } from "vee-validate";

export default {
  components: {
    CardPageTitle,
    InputEmail,
    AlertError,
    ButtonSubmitForms,
    ValidationObserver,
  },
  props: {
    value: {
      type: Object,
      require: true,
    },
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
  },
  methods: {
    submitEmail() {
      this.$emit("submit-email");
    },
  },
};
</script>
