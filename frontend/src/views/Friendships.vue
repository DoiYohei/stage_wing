<template>
  <v-container>
    <v-row>
      <v-tabs v-model="tab" background-color="transparent" color="basil" grow>
        <v-tab>Friends</v-tab>
        <v-tab>Friend申請中</v-tab>
        <v-tab>Friend申請されている</v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item>
          <v-card color="basil" float>
            <v-card-text v-for="(friend, index) in friends" :key="index">
              {{ friend.name }}
              <v-btn
                color="primary"
                elevation="2"
                outlined
                @click="deleteFriendship(friend)"
              >
                Friendです
              </v-btn>
            </v-card-text>
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card color="basil" float>
            <v-card-text v-for="(inviting, index) in invitings" :key="index">
              {{ inviting.name }}
              <v-btn
                color="primary"
                elevation="2"
                outlined
                @click="deleteFriendship(inviting)"
              >
                Friend申請中
              </v-btn>
            </v-card-text>
          </v-card>
        </v-tab-item>
        <v-tab-item>
          <v-card color="basil" float>
            <v-card-text v-for="(inviter, index) in inviters" :key="index">
              {{ inviter.name }}
              <v-btn
                color="primary"
                elevation="2"
                @click="postFriendship(inviter)"
              >
                Friend承認する
              </v-btn>
            </v-card-text>
          </v-card>
        </v-tab-item>
      </v-tabs-items>
    </v-row>
  </v-container>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      tab: null,
      items: ["Friends", "Friend申請中", "Friend申請されている"],
      friends: [],
      invitings: [],
      inviters: [],
    };
  },
  async created() {
    const token = { headers: this.$store.getters.token };
    const res = await this.$axios.get(`/bands/${this.id}/friendships`, token);
    this.friends = res.data.friends;
    this.invitings = res.data.inviting;
    this.inviters = res.data.inviters;
  },
  methods: {
    deleteFriendship(following) {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("followed_id", following.id);
      this.$axios.delete("/friendships", token, formData);
      if (this.friends.some((friend) => friend.id === following.id)) {
        const newFriends = this.friends.filter(
          (friend) => friend.id !== following.id
        );
        this.friends = newFriends;
        return this.inviters.push({ id: following.id, name: following.name });
      }
      const newInvitings = this.invitings.filter(
        (inviting) => inviting.id !== following.id
      );
      this.invitings = newInvitings;
    },
    postFriendship(following) {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("followed_id", following.id);
      this.$axios.post("/friendships", formData, token);
      const newInviters = this.inviters.filter(
        (inviter) => inviter.id !== following.id
      );
      this.inviters = newInviters;
      this.friends.push({ id: following.id, name: following.name });
    },
  },
};
</script>
