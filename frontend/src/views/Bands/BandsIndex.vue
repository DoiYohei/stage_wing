<template>
  <v-container fluid>
    <v-row>
      <v-col
        :cols="serchCols"
        class="pa-0 pt-lg-6 pr-lg-3 pl-lg-4 pr-xl-1 pl-xl-6"
      >
        <v-card color="grey darken-4" flat>
          <v-col lg="12" sm="6" class="py-0 py-lg-3 px-2 px-sm-3 px-lg-3">
            <SearchInputName v-model="keyword" label="Band" />
          </v-col>
        </v-card>
      </v-col>
      <v-col class="px-1 px-sm-3 pl-lg-0 pl-xl-2">
        <v-card color="#121212" flat class="d-flex flex-wrap">
          <v-col
            v-for="(band, index) in bandsForShow"
            :key="index"
            :cols="bandCols"
          >
            <v-card :to="`/bands/${band.id}`">
              <v-img :src="bandImage(band.image.url)" aspect-ratio="1.37" />
              <v-card-subtitle
                class="text-subtitle-1 font-weight-black text-truncate"
              >
                {{ band.name }}
              </v-card-subtitle>
            </v-card>
          </v-col>
        </v-card>
        <v-col>
          <PaginationBlocks
            v-model="page"
            :contents="filteredBands"
            :rows="rows"
          />
        </v-col>
        <v-col v-if="!bandsForShow.length">
          <v-card color="#121212" flat>
            <v-card-text class="text-center">
              該当するアーティストがいません
            </v-card-text>
          </v-card>
        </v-col>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import SearchInputName from "@/components/SearchInputs/SearchInputName";
import PaginationBlocks from "@/components/PaginationBlocks";
import { narrowDownNames } from "@/utils/searches";
import { sliceContentsForShow } from "@/utils/pagination";
import { respondCols } from "@/utils/grids";
import { bandImage } from "@/utils/images";

export default {
  components: {
    SearchInputName,
    PaginationBlocks,
  },
  data() {
    return {
      allBands: [],
      keyword: "",
      bandsForShow: [],
      page: 1,
    };
  },
  async created() {
    const res = await this.$axios.get("/bands");
    this.allBands = res.data.bands;
    this.sliceBandsForShow();
  },
  computed: {
    serchCols() {
      return respondCols(this.$vuetify.breakpoint, 2, 3, 12, 12, 12);
    },
    bandCols() {
      return respondCols(this.$vuetify.breakpoint, 2, 3, 3, 4, 6);
    },
    filteredBands() {
      return narrowDownNames(this.keyword, this.allBands);
    },
    rows() {
      return this.$vuetify.breakpoint.smAndDown ? 10 : 30;
    },
    bandImage() {
      return (image) => bandImage(image);
    },
  },
  watch: {
    filteredBands() {
      this.page = 1;
      this.sliceBandsForShow();
    },
    page() {
      this.sliceBandsForShow();
    },
  },
  methods: {
    sliceBandsForShow() {
      this.bandsForShow = sliceContentsForShow(
        this.filteredBands,
        this.page,
        this.rows
      );
    },
  },
};
</script>
