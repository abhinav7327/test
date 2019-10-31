import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRoute, Router } from '@angular/router';
import { MoviesService } from './../movies.service';
import { HomeComponent } from './home.component';
describe('HomeComponent', () => {
  let component: HomeComponent;
  let router: Router;
  let activatedRoute: ActivatedRoute;
  let moviesService: MoviesService;
  let fixture: ComponentFixture<HomeComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [HomeComponent],
      imports: [MoviesService, ActivatedRoute, Router],
      schemas: [CUSTOM_ELEMENTS_SCHEMA],
    }).compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HomeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should behave...', () => {
    /* component = new HomeComponent(moviesService, activatedRoute, router); */
    component.unitTestResult();
    expect(component.unitTestResult()).toEqual(0);
  });
});
