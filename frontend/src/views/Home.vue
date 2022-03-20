<template>
  <v-container fluid class="pa-0 fill-height">
    <v-row class="fill-height">
      <v-col cols="9" class="pa-0 fill-height">
        <v-img src="@/assets/img/home.jpg" class="fill-height" />
      </v-col>
      <v-col>
        <CardHome :card-items="cardItems">
          <template v-if="token">
            <v-list-item>
              <v-list-item-content>
                <v-card-title @click="drawer = !drawer">My Menu</v-card-title>
              </v-list-item-content>
            </v-list-item>
            <v-list-item>
              <v-list-item-content>
                <v-dialog v-model="dialog" width="45vw">
                  <template #activator="{ on, attrs }">
                    <v-card-title v-bind="attrs" v-on="on">
                      Log Out
                    </v-card-title>
                  </template>
                  <CardDialog
                    dialog-text="ログアウトしますか？"
                    :select-excution="logout"
                    :select-cancel="closeDialog"
                  />
                </v-dialog>
              </v-list-item-content>
            </v-list-item>
          </template>
        </CardHome>
        <NavigationMenu v-model="drawer" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import CardHome from "@/components/Cards/CardHome";
import CardDialog from "@/components/Cards/CardDialog";
import NavigationMenu from "@/components/NavigationMenu";

export default {
  components: {
    CardHome,
    CardDialog,
    NavigationMenu,
  },
  data() {
    return {
      cardItems: [
        {
          text: "Events",
          path: "/events",
        },
        {
          text: "Bands",
          path: "/bands",
        },
      ],
      authItems: [
        {
          text: "Sign Up (Artist)",
          path: "/signup/bands",
        },
        {
          text: "Sign Up (Audience)",
          path: "/signup/audiences",
        },
        {
          text: "Log In",
          path: "/login",
        },
      ],
      drawer: false,
      dialog: false,
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
    ...mapGetters(["isAuthenticatedBand", "isAuthenticatedAudience", "token"]),
  },
  methods: {
    ...mapActions(["logout"]),
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
