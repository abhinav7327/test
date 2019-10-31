import { Component, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { IMovie } from '../movie';
import { MoviesService } from './../movies.service';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css'],
})
export class HomeComponent implements OnInit, OnDestroy {
  public language: string;
  error = false;
  constructor(private movieService: MoviesService, private activatedRoute: ActivatedRoute, private router: Router) {}
  public movies: IMovie[];
  public searchValue: string;
  private subscriptions = new Subscription();
  ngOnInit() {
    this.subscriptions.add(this.subscribeForNavBarSearch());
    this.subscriptions.add(this.fetchMoviesByLanguage());
  }

  fetchMoviesByLanguage() {
    this.activatedRoute.params.subscribe((params) => {
      this.language = params.language;
      this.movieService.getMoviesList(this.language).subscribe(
        (data) => {
          this.movies = data;
          this.error = false;
        },
        (error) => (this.error = true)
      );
    });
  }

  openMovie(imdbid: string) {
    if (imdbid != null) {
      this.router.navigate(['/movies/details/' + imdbid]);
    }
  }
  ngOnDestroy(): void {
    this.subscriptions.unsubscribe();
  }

  subscribeForNavBarSearch() {
    this.movieService.getSearchText().subscribe((searchValue) => {
      this.searchValue = searchValue;
      for (const movie of this.movies) {
        if (movie.Title.toLowerCase() === this.searchValue.toLocaleLowerCase()) {
          this.openMovie(movie.imdbID);
          break;
        }
      }
    });
  }

  unitTestResult() {
    return 0;
  }
}
