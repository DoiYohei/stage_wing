<template>
  <div>
    <h1>Sign Up</h1>
    <v-container>
      <v-row>
        <v-col md="2" offset-md="5">
          <div>Bandの方はこちら</div>
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="bandName" label="Band Name" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="bandEmail" label="Email" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field
            v-model="bandPassword"
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
            v-model="bandImage"
            @change="fetchBandUrl"
            label="プロフィール画像"
            placeholder="ファイルを選択してください"
            chips
          />
        </v-col>
        <v-col md="2">
          <v-img v-if="bandUrl" :src="bandUrl" />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="signUpBand">Sign Up</v-btn>
        </v-col>
      </v-row>
      <v-row>
        <v-col md="2" offset-md="5">
          <div>一般の方はこちら</div>
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="audienceName" label="Name or Nickname" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field v-model="audienceEmail" label="Email" />
        </v-col>
        <v-col md="2" offset-md="5">
          <v-text-field
            v-model="audiencePassword"
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
            v-model="audienceImage"
            @change="fetchAudienceUrl"
            label="プロフィール画像"
            placeholder="ファイルを選択してください"
            chips
          />
        </v-col>
        <v-col md="2">
          <v-img v-if="audienceUrl" :src="audienceUrl" />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="signUpAudience">Sign Up</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      bandName: "",
      bandEmail: "",
      bandPassword: "",
      bandImage: [],
      bandUrl: "",
      audienceName: "",
      audienceEmail: "",
      audiencePassword: "",
      audienceImage: [],
      audienceUrl: "",
      visible: false,
    };
  },
  methods: {
    fetchBandUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.bandUrl = fr.result;
          });
        }
      } else {
        this.bandUrl = "";
      }
    },
    fetchAudienceUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.audienceUrl = fr.result;
          });
        }
      } else {
        this.audienceUrl = "";
      }
    },
    signUpBand() {
      const formData = new FormData();
      formData.append("name", this.bandName);
      formData.append("email", this.bandEmail);
      formData.append("password", this.bandPassword);
      formData.append("image", this.bandImage);
      this.$store.dispatch("signupBand", formData);
    },
    signUpAudience() {
      const formData = new FormData();
      formData.append("name", this.audienceName);
      formData.append("email", this.audienceEmail);
      formData.append("password", this.audiencePassword);
      formData.append("image", this.audienceImage);
      this.$store.dispatch("signupAudience", formData);
    },
  },
};
</script>
