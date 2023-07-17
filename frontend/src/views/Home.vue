<template>
  <v-container fluid class="pa-0 fill-height">
    <v-row class="fill-height">
      <v-col cols="12" md="8" xl="9" class="pa-0" :class="fillHeightOrNot">
        <v-img :src="homeImage" :class="fillHeightOrNot" />
        <TheHomeSmallList
          v-if="$vuetify.breakpoint.smAndDown"
          v-model="drawer"
          @open-dialog="openDialog"
          :card-items="cardItems"
          :text-style="textStyle"
          class="mx-6 my-1"
        />
      </v-col>
      <TheHomeLargeList
        v-if="$vuetify.breakpoint.mdAndUp"
        v-model="drawer"
        @open-dialog="openDialog"
        :card-items="cardItems"
        :text-style="textStyle"
      />
      <DialogYesNo
        v-model="dialog"
        question="ログアウトしますか？"
        @select-excution="logOut"
        @close-dialog="closeDialog"
      />
    </v-row>
  </v-container>
</template>

<script>
import TheHomeSmallList from "@/components/TheHomes/TheHomeSmallList";
import TheHomeLargeList from "@/components/TheHomes/TheHomeLargeList";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import { mapActions, mapGetters } from "vuex";

export default {
  components: {
    TheHomeSmallList,
    TheHomeLargeList,
    DialogYesNo,
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
      defaultItems: [
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
          path: "/signup",
        },
        {
          text: "LOG IN",
          path: "/login",
        },
      ],
      dialog: false,
    };
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
    cardItems() {
      if (!this.token) {
        return [...this.defaultItems, ...this.authItems];
      } else return this.defaultItems;
    },
    textStyle() {
      const weight = "font-weight-black";
      const flex = "justify-center";
      if (this.$vuetify.breakpoint.lgAndUp) {
        return weight + " text-h2";
      } else if (this.$vuetify.breakpoint.md) {
        return weight + " text-h3";
      } else if (this.$vuetify.breakpoint.sm) {
        return "text-h4 " + flex;
      } else return "text-h6 " + flex;
    },
    fillHeightOrNot() {
      return this.$vuetify.breakpoint.mdAndUp ? "fill-height" : "";
    },
  },
  methods: {
    async logOut() {
      await this.logout();
      this.closeDialog();
    },
    openDialog() {
      this.dialog = true;
    },
    closeDialog() {
      this.dialog = false;
    },
    ...mapActions(["logout"]),
  },
};
</script>
