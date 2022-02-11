<template>
  <v-row>
    <v-col xl="4" offset-xl="4" lg="6" offset-lg="3" sm="8" offset-sm="2">
      <v-card>
        <v-col cols="10" offset="1">
          <v-card-text>
            <span class="d-flex">
              <v-avatar size="50">
                <v-img v-if="imageUrl" :src="imageUrl" />
                <v-img v-if="!imageUrl" src="@/assets/img/no_avatar.jpeg" />
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
          <v-card-text>
            <v-btn elevation="4" @click="submitForms">
              {{ btnText }}
            </v-btn>
          </v-card-text>
        </v-col>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
export default {
  props: {
    value: {
      type: Object,
      require: true,
    },
    deliveryForms: {
      type: Function,
      require: true,
    },
    btnText: {
      type: String,
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
      this.deliveryForms(this.inputImage);
    },
  },
};
</script>
