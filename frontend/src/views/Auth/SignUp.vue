<template>
  <div>
    <h1>Sign Up</h1>
    <v-container>
      <v-row>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="name" label="Band Name" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="email" label="Email" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field
            v-model="password"
            :append-icon="visible ? 'mdi-eye' : 'mdi-eye-off'"
            :type="visible ? 'text' : 'password'"
            label="Password"
            hint="最低8文字です"
            counter
            @click:append="visible = !visible"
          />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-file-input
            v-model="image"
            @change="fetchUrl"
            label="プロフィール画像"
            placeholder="ファイルを選択してください"
            chips
          />
        </v-col>
        <v-col md="2">
          <v-img v-if="url" :src="url" />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="signUp">Sign Up</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: "",
      email: "",
      password: "",
      image: [],
      url: "",
      visible: false,
    };
  },
  methods: {
    fetchUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        }
        const fr = new FileReader();
        fr.readAsDataURL(file);
        fr.addEventListener("load", () => {
          this.url = fr.result;
        });
      } else {
        this.url = "";
      }
    },
    signUp() {
      const formData = new FormData();
      formData.append("name", this.name);
      formData.append("email", this.email);
      formData.append("password", this.password);
      formData.append("image", this.image);
      this.$store.dispatch("signup", formData);
    },
  },
};
</script>
