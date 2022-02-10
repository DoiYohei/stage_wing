<template>
  <v-row>
    <v-col>
      <v-card>
        <v-col class="d-flex justify-md-start flex-wrap">
          <v-col md="7" sm="12">
            <v-card-text>
              <v-img v-if="imageUrl" :src="imageUrl" />
              <v-img v-if="!imageUrl" src="@/assets/img/no-image.jpg" />
            </v-card-text>
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
              <v-text-field v-model="inputBand.name" label="Band Name" />
              <v-text-field v-model="inputBand.email" label="Email" />
              <v-text-field
                v-if="inputBand.password !== undefined"
                v-model="inputBand.password"
                :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
                :type="visible ? 'text' : 'password'"
                label="Password"
                hint="最低8文字です"
                counter
                @click:append="visible = !visible"
              />
              <v-text-field
                v-model="inputBand.website"
                label="ホームページURL"
              />
              <v-text-field v-model="inputBand.twitter" label="Twitter URL" />
            </v-card-text>
            <v-card-text>
              <v-textarea
                v-model="inputBand.profile"
                label="Profile"
                auto-grow
                filled
              />
            </v-card-text>
            <v-card-actions>
              <v-btn width="100%" elevation="4" @click="submitForms">
                {{ btnText }}
              </v-btn>
            </v-card-actions>
          </v-col>
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
    inputBand: {
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
