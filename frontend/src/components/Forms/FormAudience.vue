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
            <v-card-text>
              <span class="d-flex">
                <v-avatar size="50">
                  <v-img v-if="imageUrl" :src="imageUrl" />
                  <v-img
                    v-if="!imageUrl"
                    src="@/assets/img/no-audience-img.jpeg"
                  />
                </v-avatar>
                <v-file-input
                  v-model="inputImage"
                  @change="fetchImageUrl"
                  @blur="fetchOriginal"
                  label="プロフィール画像"
                  chips
                  class="ml-8"
                />
              </span>
              <v-text-field v-model="audience.name" label="Name" />
              <v-text-field v-model="audience.email" label="Email" />
              <v-text-field
                v-if="audience.password !== undefined"
                v-model="audience.password"
                :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
                :type="visible ? 'text' : 'password'"
                label="Password"
                hint="最低8文字です"
                counter
                @click:append="visible = !visible"
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
    audience: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
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
