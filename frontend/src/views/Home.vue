<template>
  <v-container fluid class="pa-0 fill-height">
    <v-row class="fill-height">
      <v-col cols="12" md="8" xl="9" class="pa-0" :class="fillHeightOrNot">
        <v-img :src="homeImage" :class="fillHeightOrNot" />
      </v-col>
      <v-col>
        <v-card flat>
          <v-list color="#121212">
            <v-list-item-group>
              <v-list-item
                v-for="(item, index) in cardItems"
                :key="index"
                :to="item.path"
              >
                <v-list-item-content>
                  <v-card-title v-text="item.text" :class="textStyle" />
                </v-list-item-content>
              </v-list-item>
              <template v-if="token">
                <v-list-item>
                  <v-list-item-content>
                    <v-card-title @click="drawer = !drawer" :class="textStyle">
                      MY MENU
                    </v-card-title>
                  </v-list-item-content>
                </v-list-item>
                <v-list-item>
                  <v-list-item-content>
                    <v-dialog v-model="logoutDialog" width="45vw">
                      <template #activator="{ on, attrs }">
                        <v-card-title
                          v-bind="attrs"
                          v-on="on"
                          :class="textStyle"
                        >
                          LOG OUT
                        </v-card-title>
                      </template>
                      <DialogYesNo
                        dialog-text="ログアウトしますか？"
                        @select-excution="logOut"
                        @close-dialog="closeDialog"
                      />
                    </v-dialog>
                    <DialogShowText v-model="errorDialog">
                      {{ errorMessage }}
                    </DialogShowText>
                  </v-list-item-content>
                </v-list-item>
              </template>
            </v-list-item-group>
          </v-list>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import DialogShowText from "@/components/Dialogs/DialogShowText";

export default {
  components: {
    DialogYesNo,
    DialogShowText,
  },
  props: {
    value: {
      type: Boolean,
      require: true,
    },
  },
  data() {
    return {
      homeImage: require("@/assets/img/home.jpg"),
      cardItems: [
        {
          text: "EVENT",
          path: "/events",
        },
        {
          text: "BAND",
          path: "/bands",
        },
      ],
      authItems: [
        {
          text: "SIGN UP",
          path: "/signup/bands",
        },
        {
          text: "SIGN UP",
          path: "/signup/audiences",
        },
        {
          text: "LOG IN",
          path: "/login",
        },
      ],
      errorDialog: false,
      errorMessage: "",
    };
  },
  created() {
    if (!this.token) {
      for (let authItem of this.authItems) {
        this.cardItems.push(authItem);
      }
    }
  },
  computed: {
    ...mapGetters(["token"]),
    drawer: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    textStyle() {
      const weight = "font-weight-black";
      if (this.$vuetify.breakpoint.lgAndUp) {
        return weight + " text-h2";
      } else if (this.$vuetify.breakpoint.md) {
        return weight + " text-h3";
      } else return weight + " text-4 justify-center";
    },
    fillHeightOrNot() {
      if (this.$vuetify.breakpoint.mdAndUp) {
        return "fill-height";
      } else return "";
    },
  },
  methods: {
    ...mapActions(["logout"]),
    async logOut() {
      const res = await this.logout();
      this.closeDialog();
      if (res) {
        this.errorMessage = res;
        this.errorDialog = true;
      }
    },
    closeDialog() {
      this.logoutDialog = false;
    },
  },
};
</script>
