<template>
  <v-container :fluid="$vuetify.breakpoint.lg">
    <v-row v-if="$vuetify.breakpoint.mdAndDown">
      <v-col>
        <v-card>
          <v-col>
            <v-tabs v-model="tabs" background-color="grey lighten-4" fixed-tabs>
              <template v-for="(friendship, index) in friendships">
                <v-divider :key="index" v-if="index !== 0" vertical />
                <v-tab :key="friendship.header">
                  {{ friendship.header }}
                </v-tab>
              </template>
            </v-tabs>
          </v-col>
          <v-tabs-items v-model="tabs">
            <v-tab-item>
              <ListFriendships
                :bands="friends"
                :friendship="friendships[0]"
                :change-friendship="deleteFriendship"
                :revert-friendship="postFriendship"
              />
            </v-tab-item>
            <v-tab-item>
              <ListFriendships
                :bands="invitings"
                :friendship="friendships[1]"
                :change-friendship="deleteFriendship"
                :revert-friendship="postFriendship"
              />
            </v-tab-item>
            <v-tab-item>
              <ListFriendships
                :bands="inviters"
                :friendship="friendships[2]"
                :change-friendship="postFriendship"
                :revert-friendship="deleteFriendship"
              />
            </v-tab-item>
          </v-tabs-items>
        </v-card>
      </v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.lgAndUp" :dense="$vuetify.breakpoint.lg">
      <ListFriendships
        :bands="friends"
        :friendship="friendships[0]"
        :change-friendship="deleteFriendship"
        :revert-friendship="postFriendship"
      />
      <ListFriendships
        :bands="invitings"
        :friendship="friendships[1]"
        :change-friendship="deleteFriendship"
        :revert-friendship="postFriendship"
      />
      <ListFriendships
        :bands="inviters"
        :friendship="friendships[2]"
        :change-friendship="postFriendship"
        :revert-friendship="deleteFriendship"
      />
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import ListFriendships from "@/components/ListFriendships";

export default {
  components: {
    ListFriendships,
  },
  props: ["id"],
  data() {
    return {
      tabs: 0,
      friends: [],
      invitings: [],
      inviters: [],
      friendships: [
        {
          header: "Friend",
          status: "Friend",
          oppositeStatus: "Friend承認",
        },
        {
          header: "Friend申請中",
          status: "Friend申請中",
          oppositeStatus: "Friend申請",
        },
        {
          header: "Friend申請されている",
          status: "Friend承認",
          oppositeStatus: "Friend",
        },
      ],
    };
  },
  async created() {
    const res = await this.$axios.get(
      `/bands/${this.id}/friendships`,
      this.headers
    );
    this.friends = res.data.friends;
    this.invitings = res.data.inviting;
    this.inviters = res.data.inviters;
  },
  computed: {
    ...mapGetters(["headers", "token"]),
  },
  methods: {
    deleteFriendship(formData) {
      this.$axios.delete("/friendships", {
        headers: this.token,
        data: formData,
      });
    },
    postFriendship(formData) {
      this.$axios.post("/friendships", formData, this.headers);
    },
  },
};
</script>
