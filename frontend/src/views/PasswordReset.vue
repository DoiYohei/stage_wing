<template>
  <v-container>
    <CardPageTitle title="パスワード再設定" />
    <v-row>
      <v-col :cols="cols" :offset="offset">
        <v-card>
          <v-col class="pa-6">
            <ValidationObserver v-slot="{ handleSubmit }">
              <v-card-text>
                <ValidationProvider
                  name="新しい Password"
                  rules="max:128|min:8|required|confirmed:confirmation"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="password"
                    :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
                    :error-messages="errors"
                    :type="visible ? 'text' : 'password'"
                    hint="最低8文字です"
                    label="新しい Password（必須）"
                    prefix="*"
                    counter
                    @click:append="visible = !visible"
                    class="pb-2"
                  />
                </ValidationProvider>
                <ValidationProvider
                  name="確認用 Password"
                  rules="max:128|min:8|required"
                  v-slot="{ errors }"
                  vid="confirmation"
                >
                  <v-text-field
                    v-model="confirmation"
                    :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
                    :error-messages="errors"
                    :type="visible ? 'text' : 'password'"
                    hint="最低8文字です"
                    label="確認用 Password（必須）"
                    prefix="*"
                    counter
                    @click:append="visible = !visible"
                    class="pt-2"
                  />
                </ValidationProvider>
                <AlertError
                  :value="isError"
                  text="パスワードを変更できませんでした。"
                  class="mt-4 mb-0"
                />
              </v-card-text>
              <ButtonSubmitForms
                @submit-forms="handleSubmit(patchPassword)"
                text="変更する"
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
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";
import AlertError from "@/components/Alerts/AlertError";
import { ValidationObserver, ValidationProvider } from "vee-validate";
import { mapActions } from "vuex";
import { respondCols } from "@/utils/grids";
import { goTo404 } from "@/utils/routers";

export default {
  components: {
    CardPageTitle,
    ButtonSubmitForms,
    AlertError,
    ValidationObserver,
    ValidationProvider,
  },
  data() {
    return {
      headers: {},
      password: "",
      confirmation: "",
      visible: false,
      isError: false,
    };
  },
  async created() {
    try {
      const params = {
        params: {
          reset_password_token: this.$route.query.reset_password_token,
        },
      };
      const res = await this.$axios.get(`/${this.users}/password/edit`, params);
      this.headers = { headers: res.data };
    } catch (error) {
      goTo404();
    }
  },
  computed: {
    users() {
      return this.$route.query.user_type.toLowerCase();
    },
    cols() {
      return respondCols(this.$vuetify.breakpoint, 4, 6, 8, 10, 12);
    },
    offset() {
      return respondCols(this.$vuetify.breakpoint, 4, 3, 2, 1, 0);
    },
  },
  methods: {
    async patchPassword() {
      try {
        const formData = new FormData();
        formData.append("password", this.password);
        formData.append("password_confirmation", this.confirmation);
        await this.$axios.patch(
          `/${this.users}/password`,
          formData,
          this.headers
        );
        this.showResult("パスワードを変更しました。");
        this.$router.replace("/login");
      } catch (error) {
        this.isError = true;
      }
    },
    ...mapActions(["showResult"]),
  },
};
</script>
